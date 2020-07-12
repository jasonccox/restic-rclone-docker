# restic-rclone

Minimal Docker image for running scheduled backups using restic with rclone as the backend.

## Tags

Images are tagged according to the version of restic that they include. The `latest` tag always points to the image containing the most recent stable version of restic.

## Volumes

Mount the following volumes into the container:
- rclone config directory at `/root/.config/rclone` (You'll need to run `rclone config` outside of the container to generate this ahead of time.)
- data to be backed up at `/data`

## Configuration

You must provide the following environment variables (see the [restic documentation](https://restic.readthedocs.io/en/latest/040_backup.html#environment-variables) for more information and for other variables you may want to set):
- `RESTIC_REPOSITORY`
- `RESTIC_PASSWORD` or `RESTIC_PASSWORD_FILE`

The following environment variables are also useful but not required:
- `CRON` - a crontab string indicating when backups should run (default `0 0 * * *`)
- `FORGET_ARGS` - arguments to be passed to `restic forget` each time a backup is run; set to `""` to indicate that `restic forget` should not be run (default `--keep-daily 7 --keep-weekly 5 --keep-monthly 12`)
- `PRUNE_CRON` - a crontab string indicating when the repository should be pruned; set to `""` to indicate that the repository should never be pruned (default `0 3 1 * *`)
- `TZ` - the timezone the container should use (e.g. `America/Denver`)

I also recommend that you manually set the hostname of the container (using `--hostname` or `hostname:` in Docker compose) so that it stays consistent, since restic does store that information.
