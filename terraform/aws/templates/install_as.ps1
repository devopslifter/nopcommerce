      Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
      choco install habitat -y
      hab license accept
      New-NetFirewallRule -DisplayName \"Habitat TCP\" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 9631,9638
      New-NetFirewallRule -DisplayName \"Habitat UDP\" -Direction Inbound -Action Allow -Protocol UDP -LocalPort 9638
      New-NetFirewallRule -DisplayName \"NOP Commerce TCP\" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 8090
      hab sup run devopslifter/nop-commerce --bind database:sqlserver.default --peer=${peer_ip}