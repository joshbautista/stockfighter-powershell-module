Function Test-StockfighterVenue
{
    <#
        .SYNOPSIS
        Checks if the Stockfighter Venue is available.
        .DESCRIPTION
        The Test-StockfighterVenue function uses the Stockfighter API to determine if a specified venue is currently available.
        .OUTPUTS
        System.Boolean
        True indicates the venue is available. False indicates the venue is not available.
        .LINK
        https://starfighter.readme.io/docs/venue-healthcheck
    #>
    [CmdletBinding()]
    Param
    (
        [string]$Venue
    )
    
    $result = Test-StockfighterInitialization -APIBaseURI
    
    $URI = New-Object -TypeName System.Uri -ArgumentList $StockfighterAPIBaseURI, "venues/$Venue/heartbeat"
    try
    {
        $response = Invoke-RestMethod -Method Get -Uri $URI
    }
    catch [System.Net.WebException]
    {
        if ($_.Exception.Message -match '(404|500)')
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
