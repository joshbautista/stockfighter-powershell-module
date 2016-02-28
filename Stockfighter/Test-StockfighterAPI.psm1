Function Test-StockfighterAPI
{
    <#
        .SYNOPSIS
        Checks if the Stockfighter API is available.
        .DESCRIPTION
        The Test-StockfighterAPI function probes the heartbeat API endpoint to determine if the Stockfighter API is available.
        .OUTPUTS
        System.Boolean
        True indicates the API is available. False indicates the API is not available.
        .LINK
        https://starfighter.readme.io/docs/heartbeat
    #>
    [CmdletBinding()]
    Param
    (
    )
    
    $result = Test-StockfighterInitialization -APIBaseURI

    $URI = New-Object -TypeName System.Uri -ArgumentList $StockfighterAPIBaseURI, 'heartbeat'
    try
    {
        $response = Invoke-RestMethod -Method Get -Uri $URI
    }
    catch [System.Net.WebException]
    {
        if ($_.Exception.Message -match '404')
        {
            $response = ConvertFrom-Json $_.ErrorDetails.Message
            Write-Error -Message $response.error
            return $response
        }
        else
        {
            Throw
        }
    }

    if ($response.ok -eq 'True')
    {
        return $true
    }
    else
    {
        return $false
    }
}
