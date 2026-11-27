
## Configures the "off-ramp"/cloudflared side of the ZTA
resource "cloudflare_zero_trust_tunnel_cloudflared" "okd_homelab" {
  account_id = var.cloudflare_account_id
  name       = "OKD Homelab"
  config_src = "cloudflare"
}

resource "cloudflare_zero_trust_tunnel_cloudflared_route" "okd_homelab_cidr" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.okd_homelab.id
  network    = var.okd_network_cidr
  comment    = "OKD Homelab Private Network"
}


data "cloudflare_zero_trust_tunnel_cloudflared_token" "okd_homelab_access" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.okd_homelab.id
}
