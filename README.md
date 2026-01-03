# Node Automation (n8n - nodemation) [tf-proxmox-n8n](https://github.com/lucidsolns/tf-proxmox-n8n)

A deployment of n8n on proxmox with Flatcar Linux. The containers
are run with Podman and Quadlet.

The deployment is:
  - a master n8n node
  - a worker n8n node
  - two runner nodes
  - a redis and postgres container for storage


# Owner Account

n8n does not use environment variables for the owner account's email or password. The initial
owner account is set up interactively when the n8n instance starts for the first time.

Thus I would highly recommend not making the site public until this is done.

# Links

- https://n8n.io/
- https://github.com/lawrencesystems/n8n/blob/main/compose.yaml
- https://www.youtube.com/watch?v=Vyppuv98Cgs
- https://forums.lawrencesystems.com/t/n8n-2-0-docker-setup-tutorial/26304
- https://chatgpt.com/share/693c8ccf-7d48-8011-8ae2-d49bbc3c6ae7
- https://www.youtube.com/watch?v=ZCuL2e4zC_4
- https://www.youtube.com/watch?v=KLDgOn7VuPg
