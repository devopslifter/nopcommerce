
# nopCommerce

Habitat Plan for nop-commerce

## Maintainers

Tom Finch tfinch@chef.io

## Type of Package

This is a Habitat service package

## Usage

This package is used to run the nop-commerce web application, it is recommended to add a post `post_run` hook to your sqlserver package to customise any database changes, create users and add any necessary privileges.

## Bindings

This package binds to Microsoft SQL Server 2008 or higher and contains all the necesary `.sql` quieries to create a starter database.
 
Example bind

`hab svc load devopslifter/nop-commerce --bind database:sqlserver.default`

## Topologies

TODO

## Notes

Learning points:

Publish is for src/presentation/nop.web/nop.web.csproj NOT the solution file

Use $pkg_svc_run for simple run

Use Get-HabPackagePath to point at the correct dotnet bin

Kestrel defaults to port 5000 on ASP.net core (causes issues with getting to the app in a container) Added workaroud in program.cs

SQL Server PS module needs to be loaded from host (hooj nuance)
