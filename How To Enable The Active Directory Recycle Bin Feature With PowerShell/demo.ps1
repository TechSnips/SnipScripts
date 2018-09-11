Get-ADOptionalFeature -Identity 'Recycle Bin Feature'

(Get-ADForest).ForestMode

$SplatParams = @{
    Identity = 'Recycle Bin Feature'
    Target   = 'techsnips-test.local'
    Scope    = 'ForestOrConfigurationSet'
}
Enable-ADOptionalFeature @SplatParams

(Get-ADOptionalFeature -Identity 'Recycle Bin Feature').EnabledScopes
