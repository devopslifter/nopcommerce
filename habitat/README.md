
# nopCommerce

Habitat Plan for NopCommerce

## Maintainers

Tom Finch tfinch@chef.io

## Type of Package

This is a Habitat service package

## Usage

This package is used to run the NopCommerce web application, to customise your MS SQL Server instance it is recommended to add a `post_run` hook to your sqlserver package to customise any database changes, create users and add any necessary privileges you require.

## Bindings

This package binds to Microsoft SQL Server 2008 or higher and contains all the necesary `.sql` quieries to create a starter database.
 
Example bind

`hab svc load devopslifter/nop-commerce --bind database:sqlserver.default`

## Topologies

TODO
