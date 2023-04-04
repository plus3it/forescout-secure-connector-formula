{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set RpmVrfySetting = '/etc/rpm/macros.verify' %}

{%- from tplroot ~ "/map.jinja" import mapdata as forescout with context %}

ForeScout OS Log-Dir Setup:
  file.directory:
    - group: 'root'
    - mode: '0755'
    - name: '/var/log/forescout'
    - selinux:
        serange: 's0'
        serole: 'object_r'
        setype: 'lib_t'
        seuser: 'system_u'

ForeScout SecureConnector Dependencies Installed:
  pkg.installed:
    - pkgs:
        - bzip2
        - wget
    - user: 'root'

ForeScout SecureConnector Archive Extracted:
  archive.extracted:
    - name: {{ forescout.package.archive.extract_directory }}
    - source: {{ forescout.package.archive.source }}
    - source_hash: {{ forescout.package.archive.source_hash }}
    - user: root
    - group: root
    - mode: 0700

Relax pkgverify options:
  file.managed:
    - contents: '%_pkgverify_level none'
    - group: 'root'
    - mode: '0600'
    - name: '{{ RpmVrfySetting }}'
    - user: 'root'
    - selinux:
        serange: 's0'
        serole: 'object_r'
        setype: 'etc_t'
        seuser: 'system_u'
    - unless:
      - '[[ {{ grains["osmajorrelease"] }} -lt 8 ]]'

{%- if forescout.package.daemon.get('source') %}
ForeScout SecureConnector Daemon Installed:
  pkg.installed:
    - setopt:
      - tsflags=nocrypto
    - sources:
      - {{ forescout.package.daemon.name }}: {{ forescout.package.daemon.source }}
    - skip_verify: True
    - require:
      - file: Relax pkgverify options
    - require_in:
      - cmd: ForeScout SecureConnector Installed
{%- endif %}

ForeScout SecureConnector Installed:
  cmd.run:
    - name: {{ forescout.package.archive.extract_directory }}/{{ forescout.package.install_cmd }}
    - unless: {{ forescout.package.installed_test }}
    - require:
      - archive: ForeScout SecureConnector Archive Extracted
      - pkg: ForeScout SecureConnector Dependencies Installed

ForeScout Symlink to OS Log-Dir:
  file.symlink:
    - group: 'root'
    - makedirs: True
    - mode: '0755'
    - name: '/usr/lib/forescout/bin/log'
    - require:
      - file: Forescout Zap Default Log-Dir
    - target: '/var/log/forescout'
    - user: 'root'

Forescout Zap Default Log-Dir:
  file.absent:
    - name: '/usr/lib/forescout/bin/log'
    - onlyif:
      - '[[ -d /usr/lib/forescout/bin/log ]]'
    - require:
      - file: ForeScout OS Log-Dir Setup
      - cmd: ForeScout SecureConnector Installed

Restore pkgverify options:
  file.absent:
    - name: '{{ RpmVrfySetting }}'
    - require:
      - cmd: ForeScout SecureConnector Installed
