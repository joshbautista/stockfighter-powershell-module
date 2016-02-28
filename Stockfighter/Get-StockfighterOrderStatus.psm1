Function Get-StockfighterOrderStatus
{
    <#
        .SYNOPSIS
        Gets the order status for a given venue, stock, order ID or account number.
        .DESCRIPTION
        The Get-StockfighterOrderStatus function utilizes the Stockfighter REST API in order to retrieve the order status for the provided venue, stock, order ID or account. This function supports getting the order status for a specific order, status for all orders associated with a venue and account, and all orders associated with a venue and account filtered by stock.
        .PARAMETER OrderID
        Specifies the globally unique ID (per venue) received when an order is placed.
        .PARAMETER Venue
        Specifies the venue hosting the stock to be inspected.
        .PARAMETER Stock
        Specifies the stock to get the order status for.
        .PARAMETER Account
        Specifies the trading account name.
        .LINK
        https://starfighter.readme.io/docs/status-for-an-existing-order
    #>
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,ParameterSetName="Existing")]
        [Parameter(Mandatory=$true,ParameterSetName="All")]
        [Parameter(Mandatory=$true,ParameterSetName="ByStock")]
        [ValidateNotNullOrEmpty()]
        [string]$Venue,
        [Parameter(Mandatory=$true,ParameterSetName="Existing")]
        [Parameter(Mandatory=$true,ParameterSetName="ByStock")]
        [ValidateNotNullOrEmpty()]
        [string]$Stock,
        [Parameter(Mandatory=$true,ParameterSetName="All")]
        [Parameter(Mandatory=$true,ParameterSetName="ByStock")]
        [ValidateNotNullOrEmpty()]
        [string]$Account,
        [Parameter(Mandatory=$true,ParameterSetName="Existing")]
        [ValidateNotNullOrEmpty()]
        [string]$OrderID
    )

    $result = Test-StockfighterInitialization -APIBaseURI -APIKey
    
    switch ($PSCmdlet.ParameterSetName)
    {
        "Existing" { $URI = New-Object -TypeName System.Uri -ArgumentList $StockfighterAPIBaseURI, "venues/$Venue/stocks/$Stock/orders/$OrderID" }
        "All" { $URI = New-Object -TypeName System.Uri -ArgumentList $StockfighterAPIBaseURI, "venues/$Venue/accounts/$Account/orders" }
        "ByStock" { $URI = New-Object -TypeName System.Uri -ArgumentList $StockfighterAPIBaseURI, "venues/$Venue/accounts/$Account/stocks/$Stock/orders" }
    }
    
    $headers = @{
        'X-Starfighter-Authorization' = $StockfighterAPIKey
    }
    try
    {
        $response = Invoke-RestMethod -Method Get -Uri $URI -Headers $headers
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
