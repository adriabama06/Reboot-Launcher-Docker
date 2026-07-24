# Reboot-Launcher-Docker
A Docker ready for Reboot-Launcher

Note: Use with https://github.com/adriabama06/LawinServerMultiAccount

### Quick guide
```bash
docker compose up -d

# Go to http://yourip:6080/
# Put your game files in builds folder it should look like:
builds/
└── 7.40
    ├── Engine
    │   ├── Binaries
    │   └── Programs
    └── FоrtnіtеGаmе
        ├── Binaries
        ├── Content
        └── PersistentDownloadDir

# In the web go to server, import the version, selecting the path, as example: /root/RebootLauncher/builds/7.40

# Then click on start server, it usually crashes at the start, so try starting again, it takes 1 to 5 times to correcly start

```