Function Get-StockfighterQuote
{
    <#
        .SYNOPSIS
        Gets the current quote for a given venue and stock.
        .DESCRIPTION
        The Get-StockfighterQuote function utilizes the Stockfighter REST API in order to retrieve a quote for the provided venue and stock.
        .PARAMETER Venue
        Specifies the venue hosting the stock to be inspected.
        .PARAMETER Stock
        Specifies the stock to get the quote for.
        .LINK
        https://starfighter.readme.io/docs/a-quote-for-a-stock
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

    $URI = New-Object -TypeName System.Uri -ArgumentList $StockfighterAPIBaseURI, "venues/$Venue/stocks/$Stock/quote"
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
