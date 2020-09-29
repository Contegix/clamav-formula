# -*- coding: utf-8 -*-
# vim: ft=sls

{%- from "clamav/map.jinja" import clamav with context %}
{%- set freshclam = clamav.get('freshclam', {}) %}

freshclam_pkg:
  pkg.installed:
    - pkgs:
{%- for pkg in freshclam.pkgs %}
      - {{ pkg }}
{%- endfor %}

{% set logpath = salt['pillar.get']('clamav.freshclam.config.UpdateLogFile', '/var/log/clamav/freshclam.log') %}
{{ logpath }}:
  file.managed:
    - makedirs: True
