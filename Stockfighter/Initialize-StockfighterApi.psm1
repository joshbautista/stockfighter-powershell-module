Function Initialize-StockfighterApi
{
    <#
        .SYNOPSIS
        Initializes setup variables in order to use the Stockfighter API Powershell wrapper.
        .DESCRIPTION
        The Initialize-StockfighterApi function sets a couple of variables used by the other functions included with the Stockfighter API Powershell wrapper. The APIBaseURI has a default value, but both the APIBaseURI and APIKey may be set using parameters.
        .PARAMETER StockfighterAPIBaseURI
        Specifies the Stockfighter API Base URI.
        .PARAMETER StockfighterAPIKey
        Specifies a Stockfighter API key used for operations requiring authentication.
    #>
    Param
    (
        [string]$StockfighterAPIBaseURI = 'https://api.stockfighter.io/ob/api/',
        [string]$StockfighterAPIKey
    )
    
    $Global:StockfighterAPIBaseURI = New-Object -TypeName System.Uri -ArgumentList $StockfighterApiBaseURI
    $Global:StockfighterAPIKey = $StockfighterAPIKey
}
