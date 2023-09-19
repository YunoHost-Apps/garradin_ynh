# Garradin becomes Paheko!
## Why change your name?

It appeared that the pronunciation of "Garradin" in French is sometimes a bit complicated, as is its spelling.

There is already a commercial software called "Garradin" in Australia, which does finance for large groups. For the moment this was not a problem because our association management solution was only available in French and until then did not have much scope. But we would like to be able to offer the software in other languages in the years to come, and as Garradin (the French project) is starting to be quite well known, it seems necessary to limit the risk of confusion in the future with this commercial solution.

You can now upgrade Garradin with Paheko ! 
Don't stay with this repository, it will be no more supported.

Read the instructions how to migrate your application Garradin to Paheko: 

### Migrate from Garradin

Process the migration from Garradin to Paheko. For that, you will have to upgrade your Garradin application with this repository. This can only be done from the command-line interface - e.g. through SSH. Once you're connected, you simply have to execute the following:

```bash
sudo yunohost app upgrade garradin -u https://github.com/YunoHost-Apps/paheko_ynh/tree/garradin-migration --debug
```

The --debug option will let you see the full output. If you encounter any issue, please report it aand paste the logs.

**Important**: After the migration, you'll have to wait a couple of minutes (at most 3 minutes) before you can start using Paheko.

Once the migration is done, you should then upgrade to new release of Paheko.

```bash
sudo yunohost app upgrade paheko
```
