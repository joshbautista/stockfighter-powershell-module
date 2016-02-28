Function Get-StockfighterOrderbook
{
    <#
        .SYNOPSIS
        Gets the orderbook for a given venue and stock.
        .DESCRIPTION
        The Get-StockfighterOrderbook function utilizes the Stockfighter REST API in order to retrieve an orderbook for the provided venue and stock.
        .PARAMETER Venue
        Specifies the venue hosting the stock to be inspected.
        .PARAMETER Stock
        Specifies the stock to get the orderbook for.
        .LINK
        https://starfighter.readme.io/docs/get-orderbook-for-stock
    #>
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Venue,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Stock
    )
    
    $result = Test-StockfighterInitialization -APIBaseURI

    $URI = New-Object -TypeName System.Uri -ArgumentList $StockfighterAPIBaseURI, "venues/$Venue/stocks/$Stock"
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
