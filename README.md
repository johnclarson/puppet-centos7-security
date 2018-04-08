# security

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with security](#setup)
    * [What security affects](#what-security-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with security](#beginning-with-security)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This is a basic operating system security hardening module for basic Nessus scans.
Currently, it only works with CentOS 7 but should work with most puppet versions.

## Module Description

Very basic right now. Just an init.pp with file, service and augeas rules.

## Setup

### What security affects

This module can affect many core security files and services.
*Warning* It may cause existing applications or functions to fail. Proceed with caution.

### Beginning with security

## Usage

## Reference

Classes: security

## Limitations

Only works with CentOS 7 currently.

## Development

Feel free to fork this and improve/add to it.

