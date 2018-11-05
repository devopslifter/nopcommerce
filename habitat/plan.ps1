$pkg_name="nop-commerce"
$pkg_origin="devopslifter"
$pkg_version="0.1.0"
$pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
$pkg_license=@("Apache-2.0")
$pkg_upsteam_url="https://github.com/nopSolutions/nopCommerce"
$pkg_description="NOP Commerce ASP.net app"


$pkg_deps=@("core/dotnet-core")
$pkg_build_deps=@("core/dotnet-core-sdk")


$pkg_exports=@{
    "port"="port"
}

$pkg_binds=@{
  "database"="username password port"
}

function Invoke-SetupEnvironment {
  Set-RuntimeEnv "HAB_CONFIG_PATH" $pkg_svc_config_path
}
function Invoke-Build{
  cp $PLAN_CONTEXT/../* $HAB_CACHE_SRC_PATH/$pkg_dirname -recurse -force
  & "$(Get-HabPackagePath dotnet-core-sdk)\bin\dotnet.exe" restore
  & "$(Get-HabPackagePath dotnet-core-sdk)\bin\dotnet.exe" build
  if($LASTEXITCODE -ne 0) {
      Write-Error "dotnet build failed!"
    dotnet restore "$HAB_CACHE_SRC_PATH\$pkg_dirname\nopCommerce-develop\src\NopCommerce.sln"
  }
}