# ijl20_toolz

Generally useful Linux scripts

## Login motd (message of the day)

Removes the Canonical marketing, adds system status info at login.

```
sudo vim /etc/default/motd-news
```
Change `ENABLED=1` to `ENABLED=0`.

```
sudo chmod -x /etc/update-motd.d/80-livepatch
sudo chmod -x /etc/update-motd.d/10-help-text
sudo apt install landscape-common
```
