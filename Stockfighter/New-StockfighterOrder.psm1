Function New-StockfighterOrder
{
    <#
        .SYNOPSIS
        Submits a new order to a Stockfighter stock exchange.
        .DESCRIPTION
        The New-StockfighterOrder function allows one to submit a buy or sell order on a given venue against a specified stock. Different order types are supported per the Stockfighter API.
        .PARAMETER Account
        Specifies the trading account being used for trading.
        .PARAMETER Venue
        Specifies the venue hosting the stock to be inspected.
        .PARAMETER Stock
        Specifies the stock to get the quote for.
        .PARAMETER Price
        Specifies the desired buy or sell price.
        .PARAMETER Qty
        Specifies the quantity of shares being bought or sold.
        .PARAMETER Direction
        Specifies whether or not this is a buy or sell order.
        .PARAMETER OrderType
        Specifies a specific order type.
        .LINK
        https://starfighter.readme.io/docs/place-new-order
    #>
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Account,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Venue,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Stock,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [int]$Price,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [int]$Qty,
        [Parameter(Mandatory=$true)]
        [ValidateSet('buy', 'sell')]
        [string]$Direction,
        [Parameter(Mandatory=$true)]
        [ValidateSet('limit', 'market', 'fill-or-kill', 'immediate-or-cancel')]
        [string]$OrderType
    )

    $result = Test-StockfighterInitialization -APIBaseURI -APIKey
    
    $URI = New-Object -TypeName System.Uri -ArgumentList $StockfighterAPIBaseURI, "venues/$Venue/stocks/$Stock/orders"
    $headers = @{
        'X-Starfighter-Authorization' = $StockfighterAPIKey
    }
    $body = @{
        'account' = $Account
        'price' = $Price
        'qty' = $Qty
        'direction' = $Direction
        'orderType' = $OrderType
    }
    $JSONBody = ConvertTo-Json -InputObject $body
    
    try
    {
        $response = Invoke-RestMethod -Method Post -Uri $URI -Headers $headers -Body $JSONBody -ContentType 'application/json'
    }
    catch [System.Net.WebException]
    {
        if ($_.Exception.Message -match '400' -or
            ($_.Exception.Message -match '200' -and $response.ok -eq 'False'))
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
