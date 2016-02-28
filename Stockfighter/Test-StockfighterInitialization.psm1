Function Test-StockfighterInitialization
{
    <#
        .SYNOPSIS
        Checks if specific variables for the Stockfighter API Powershell wrapper have been set.
        .DESCRIPTION
        The Test-StockfighterInitialization function verifies specific variables are set to ensure the other functions provided with this module may function properly.
        .PARAMETER APIBaseURI
        This flag controls whether or not the Stockfighter API Base URI variable should be validated.
        .PARAMETER APIKey
        This flag controls whether or not the Stockfighter API Key variable should be validated.
    #>
    Param
    (
        [switch]$APIBaseURI,
        [switch]$APIKey
    )
    
    if (-not $APIBaseURI -and -not $APIKey)
    {
        $All = $true
    }
    
    if ($APIBaseURI -or $All)
    {
        if (-not $StockfighterAPIBaseURI)
        {
            Throw 'StockfighterAPIBaseURI is not set. Please run Initialize-StockfighterApi.'
        }
    }
    
    if ($APIKey -or $All)
    {
        if (-not $StockfighterAPIKey)
        {
            Throw 'StockfighterAPIKey is not set. Please run Initialize-StockfighterApi with APIKey switch.'
        }
    }
    return $true
}
