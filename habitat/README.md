
# nopCommerce

Habitat Plan for nop-commerce

## Maintainers

The Habitat Maintainers humans@habitat.sh

## Type of Package

This is a Habitat service package

## Usage

How would a user use this package?  i.e. can a user simply call the package as a dependency of their application?  Or is there more they need to do?

## Bindings

This package binds to Microsoft SQL Server 2008 or higher

## Topologies

TODO

## Notes

Learning points:

Publish is for src/presentation/nop.web/nop.web.csproj NOT the solution file

Use $pkg_svc_run for simple run

Use Get-HabPackagePath to point at the correct dotnet bin

Kestrel defaults to port 5000 on ASP.net core (causes issues with getting to the app in a container) Added workaroud in program.cs
