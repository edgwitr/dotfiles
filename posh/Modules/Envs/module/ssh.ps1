if ($global:osEnv -eq "linux") {
  $sshCache = "$HOME/.cache/ssh.json"
  if ($null -eq $env:SSH_AUTH_SOCK) {
    if (Test-Path $sshCache) {
      $agentJson = Get-Content $sshCache | ConvertFrom-Json
      if (Get-Process -Id $agentJson.SSH_AGENT_PID -ErrorAction SilentlyContinue) {
        $env:SSH_AUTH_SOCK = $agentJson.SSH_AUTH_SOCK
        $env:SSH_AGENT_PID = $agentJson.SSH_AGENT_PID
        return
      }
    }
    $agentOutput = (ssh-agent -s) -Split '`n'
    if ($agentOutput[0] -match 'SSH_AUTH_SOCK=([^;]+)') {
      $env:SSH_AUTH_SOCK = $matches[1]
    }
    if ($agentOutput[1] -match 'SSH_AGENT_PID=(\d+);') {
      $env:SSH_AGENT_PID = $matches[1]
    }
    $info = @{
      "SSH_AUTH_SOCK" = $env:SSH_AUTH_SOCK
      "SSH_AGENT_PID" = $env:SSH_AGENT_PID
    }
    $info | ConvertTo-Json | Out-File $sshCache
  }
}

$sshAgent = Get-Process -Name ssh-agent -ErrorAction SilentlyContinue
if ($sshAgent) {
  if ((ssh-add -l) -eq "The agent has no identities.") { ssh-add }
}
