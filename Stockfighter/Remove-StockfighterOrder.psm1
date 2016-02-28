Function Remove-StockfighterOrder
{
    <#
        .SYNOPSIS
        Removes an oder from a Stockfighter orderbook.
        .DESCRIPTION
        The Remove-StockfighterOrder function utilizes the Stockfighter REST API cancel an order for a given stock and venue.
        .PARAMETER Venue
        Specifies the venue hosting the stock to be affected.
        .PARAMETER Stock
        Specifies the stock to be affected.
        .PARAMETER OrderID
        Specifies the globally unique ID (per venue) associated with the order to be canceled.
        .LINK
        https://starfighter.readme.io/docs/cancel-an-order
    #>
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Venue,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Stock,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [int]$OrderID
    )
    
    $result = Test-StockfighterInitialization -APIBaseURI -APIKey
    
    $URI = New-Object -TypeName System.Uri -ArgumentList $StockfighterAPIBaseURI, "venues/$Venue/stocks/$Stock/orders/$OrderID"
    $headers = @{
        'X-Starfighter-Authorization' = $StockfighterAPIKey
    }
    
    try
    {
        $response = Invoke-RestMethod -Method Delete -Uri $URI -Headers $headers
    }
    catch [System.Net.WebException]
    {
        if ($_.Exception.Message -match '401')
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
