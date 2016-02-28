Function Get-StockfighterStocks
{
    <#
        .SYNOPSIS
        Gets a list of stocks available on a given venue.
        .DESCRIPTION
        The Get-StockfighterStocks function utilizes the Stockfighter REST API in order to retrieve a list of stocks being traded on a provided venue.
        .PARAMETER Venue
        Specifies the venue hosting the stock to be inspected.
        .LINK
        https://starfighter.readme.io/docs/list-stocks-on-venue
    #>
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Venue
    )
    
    $result = Test-StockfighterInitialization -APIBaseURI
    
    $URI = New-Object -TypeName System.Uri -ArgumentList $StockfighterAPIBaseURI, "venues/$Venue/stocks"
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
    return $response
}
