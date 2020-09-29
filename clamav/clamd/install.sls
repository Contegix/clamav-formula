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


{% salt['pillar.get']('clamd.config.User', 'clamav') %}:
  user.present:
  - system: True
  - shell: /sbin/nologin
  - createhome: False
