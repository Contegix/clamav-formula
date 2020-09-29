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

{% set user = salt['pillar.get']('clamd.config.User', 'clamav') %}
{{ user }}:
  user.present:
   - system: True
   - shell: /sbin/nologin
   - createhome: False

{% set logpath = salt['pillar.get']('clamd.config.LogFile', '/var/log/clamav/clamd.log') %}
{{ logpath }}:
  file.managed:
    - user: {{ user }}
    - group: {{ user }}
    - makedirs: True
