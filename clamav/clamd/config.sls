# -*- coding: utf-8 -*-
# vim: ft=sls

{%- from "clamav/map.jinja" import clamav with context %}
{%- set clamd = clamav.get('clamd', {}) %}

include:
  - .install

clamd_config:
  file.managed:
    - name: {{ clamd.config_path}}/{{ clamd.config_file }}
    - source: salt://clamav/files/clamd.conf
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - require:
      - pkg: clamd_pkg

{% if grains['os_family'] == 'RedHat' %}
  {% if salt['grains.get']('selinux:enforced') == 'Enforcing' %}
antivirus_can_scan_system:
  selinux.boolean:
    - name: antivirus_can_scan_system
    - value: True
    - persist: True
    - require:
      - pkg: clamd_pkg

clamd_use_jit:
  selinux.boolean:
    - name: clamd_use_jit
    - value: True
    - persist: True
    - require:
      - pkg: clamd_pkg
  {% endif %}
{% endif %}

