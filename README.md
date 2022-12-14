# forescout-secure-connector-formula

This Salt formula will install the ForeScout Secure Connector agent. The installer
is an archive generated by the ForeScout server and includes all information needed
to link to the server.

The states in this formula are entirely configurable through pillar. See the
sections below for a description of the pillar keys.

## Available States

-   [forescout-secure-connector](#forescout-secure-connector)
-   [forescout-secure-connector.clean](#forescout-secure-connector.clean)
-   [forescout-secure-connector.package](#forescout-secure-connector.package)
-   [forescout-secure-connector.service](#forescout-secure-connector.service)

### forescout-secure-connector

Executes the `package` and `service` states to install and manage the ForeScout
Secure Connector.

### forescout-secure-connector.clean

The `clean` state will remove all ForeScout Secure Connector components that are
managed by this formula.

### forescout-secure-connector.package

The `package` state ensures the ForeScout Secure Connector is installed.

### forescout-secure-connector.service

The `service` state ensures the ForeScout Secure Connector service is running and enabled.

## Configuration

The only _required_ configuration settings are the archive source URL and its source
hash, i.e. `package:archive:source` and `package:archive:source_hash`. Those are
specific to the ForeScout server and the environment where this formula is used.

All other settings are optional. The formula sets reasonable, sane defaults for
optional settings.

All settings must be located in the Salt Pillar, within the `forescout-secure-connector:lookup`
dictionary.

### `forescout-secure-connector:lookup:package:archive:source`

URL to the ForeScout Secure Connector archive.

>**Required**: `True`

**Example**:

```yaml
forescout-secure-connector:
  lookup:
    package:
      archive:
        source: https://url/to/forescout/archive.tgz
```

### `forescout-secure-connector:lookup:package:archive:source_hash`

URL containing the source hash of the archive, or the hash value.

>**Required**: `True`

**Example**:

```yaml
forescout-secure-connector:
  lookup:
    package:
      archive:
        source_hash: source_hash_url_or_value
```

### `forescout-secure-connector:lookup:package:install_dir`

Location on the filesystem where the ForeScout agent expects to be installed.

>**Required**: `False`
>
>**Default**: `/usr/lib/forescout`

**Example**:

```yaml
forescout-secure-connector:
  lookup:
    package:
      install_dir: /usr/lib/forescout
```

### `forescout-secure-connector:lookup:package:install_cmd`

Command the ForeScout archive provides to install the Secure Connector. This command
is executed from the archive directory, after extracting the archive.

>**Required**: `False`
>
>**Default**: `secure_connector/install.sh`

**Example**:

```yaml
forescout-secure-connector:
  lookup:
    package:
      install_cmd: secure_connector/install.sh
```

### `forescout-secure-connector:lookup:package:installed_test`

Command that tests whether to run the ForeScout install command

>**Required**: `False`
>
>**Default**: `test -d /usr/lib/forescout/daemon`

**Example**:

```yaml
forescout-secure-connector:
  lookup:
    package:
      installed_test: test -d /usr/lib/forescout/daemon
```

### `forescout-secure-connector:lookup:package:uninstall_cmd`

Command used in the `clean` state to uninstall the ForeScout Secure Connector.

>**Required**: `False`
>
>**Default**: `/usr/lib/forescout/Uninstall.sh`

**Example**:

```yaml
forescout-secure-connector:
  lookup:
    package:
      uninstall_cmd: /usr/lib/forescout/Uninstall.sh
```

### `forescout-secure-connector:lookup:package:uninstall_test`

Command used in the `clean` state that tests whether the ForeScout uninstall command
is available.

>**Required**: `False`
>
>**Default**: `test -x /usr/lib/forescout/Uninstall.sh`

**Example**:

```yaml
forescout-secure-connector:
  lookup:
    package:
      uninstall_test: test -x /usr/lib/forescout/Uninstall.sh
```

### `forescout-secure-connector:lookup:package:archive:extract_directory`

Directory where the archive will be extracted

>**Required**: `False`
>
>**Default**: `{{ salt.config.get('cachedir') }}/files/base/forescout-secure-connector/package/archive/forescout`

**Example**:

```yaml
forescout-secure-connector:
  lookup:
    package:
      archive:
        extract_directory: {{ salt.config.get('cachedir') }}/files/base/forescout-secure-connector/package/archive/forescout
```

### `forescout-secure-connector:lookup:package:daemon:name`

Name of the `daemon` package required by forescout.

>**Required**: `False`
>
>**Default**: `/root/forescout`

**Example**:

```yaml
forescout-secure-connector:
  lookup:
    package:
      daemon:
        name: daemon
```

### `forescout-secure-connector:lookup:package:daemon:source`

Url to the file that installs the `daemon` package. When not provided, the archive
installer will connect to the ForeScout server to retrieve and install the `daemon`
package.

>**Required**: `False`
>
>**Default**: `None`

**Example**:

```yaml
forescout-secure-connector:
  lookup:
    package:
      daemon:
        source: https://url/to/daemon/pkg.rpm
```

### `forescout-secure-connector:lookup:package:daemon:source`

Name of the ForeScout Secure Connector service

>**Required**: `False`
>
>**Default**: `SecureConnector`

**Example**:

```yaml
forescout-secure-connector:
  lookup:
    service:
      name: SecureConnector
```
