# -*- coding: utf-8 -*-
# vim: ft=sls

{%- from "clamav/map.jinja" import clamav with context %}
{%- set clamd = clamav.get('clamd', {}) %}

clamd_pkg:
  pkg.installed:
    - pkgs:
{%- for pkg in clamd.pkgs %}
      - {{ pkg }}
{%- endfor %}

# create clamav user
{% set user = salt['pillar.get']('clamav.clamd.config.User', 'clamav') %}
{{ user }}:
  user.present:
   - system: True
   - shell: /sbin/nologin
   - createhome: False

# location for clamd socket file
/var/lib/clamav:
  file.directory:
    - user: 'clamupdate'
    - group: 'clamupdate'
    - dir_mode: 755

# location for clamd pid file
/run/clamav:
  file.directory:
    - user: {{ user }}
    - group: {{ user }}
    - dir_mode: 755

# location for clamd log file
{% set logpath = salt['pillar.get']('clamav.clamd.config.LogFile', '/var/log/clamav/clamd.log') %}
{{ logpath }}:
  file.managed:
    - user: {{ user }}
    - group: {{ user }}
    - mode: 0666
    - makedirs: True
