# node-exporter/INT3400 Thermal Zone/Sensor Workaround

**TL;DR** The ACPI/Thernal Zone tied to this sensor needs something like `thermald` in order to not
wedge syscalls for `thermal_zone_get_temp` which `node-exporter` via it's `hwmon` collector uses.

The stuff in here creates a workaround script and dumb udev rule to ack the keep-alive events
so node-exporter doesn't wedge.


## Details

> ![NOTE]: note this was created through a very long debugging session with ChatGPT where ACPI data was extracted, decompiled, and etc.
> This was diagnosed through a fairly extensive debugging session involving kernel task stacks, ACPI table
extraction/decompilation, and inspection of the Linux INT3400 interface.
> Summary below is prepared by ChatGPT as well.


The original symptom was the OpenShift-managed `node-exporter` target timing out. Numerous exporter threads
were found stuck in D-state around:

    thermal_zone_get_temp
    temp_show
    temp_input_show

One active thread consistently showed:

    acpi_ex_system_do_sleep
    acpi_evaluate_integer
    acpi_thermal_get_temperature
    thermal_zone_get_temp

Decompiling the system ACPI tables exposed the relevant firmware method:

    ThermalZone (TZ00)
    {
        Method (_TMP, 0, Serialized)
        {
            ...

            DTAL = Zero
            While ((Local0 > Zero))
            {
                Notify (\_SB.IETM, 0xA0)
                Sleep (0x03E8)

                If ((DTAL == One))
                {
                    Break
                }

                Local0--
            }

            ...

            Return (0x0BC2)
        }
    }

The zone is not a useful physical temperature sensor: `_TMP` always returns `0x0BC2`, approximately
27.85 °C. Its purpose appears to be part of the platform thermal/power-management handshake.

Linux binds the platform's `INT3400:00` device to `int3400_thermal`. The firmware `Notify(..., 0xA0)` is
surfaced by the kernel as a thermal uevent:

    NAME=INT3400 Thermal
    EVENT=8

`EVENT=8` is the INT3400 keep-alive event. The kernel also exposes a write-only sysfs attribute:

    /sys/bus/platform/devices/INT3400:00/imok

Writing `1` to this attribute acknowledges the keep-alive request.

A continuous test responder that acknowledged each `EVENT=8` caused the affected platform
`node-exporter` ServiceMonitor target to begin completing scrapes successfully again, confirming that the
missing userspace acknowledgement was the practical cause of the timeout behavior.

Updating the nodes from kernel:

    6.12.0-243.el10.x86_64

to:

    6.12.0-254.el10.x86_64

did not change the behavior.

## Workaround

Rather than installing a full thermal-policy daemon such as `thermald`, this workaround performs only the
required INT3400 keep-alive acknowledgement.

A udev rule watches for:

    SUBSYSTEM=thermal
    ACTION=change
    NAME=INT3400 Thermal
    EVENT=8

and invokes a helper that writes:

    1

to:

    /sys/bus/platform/devices/INT3400:00/imok

The workaround is installed through a MachineConfig because this is host hardware/firmware integration,
not a Kubernetes workload concern.

## Notes

This is deliberately a narrow workaround for the affected hardware. It does not disable ACPI thermal
support, modify the DSDT, or install a userspace thermal-policy engine.

The actual CPU temperature data used for monitoring comes from the normal `coretemp` hwmon device; the
problematic ACPI `TZ00` value itself is not useful temperature telemetry.