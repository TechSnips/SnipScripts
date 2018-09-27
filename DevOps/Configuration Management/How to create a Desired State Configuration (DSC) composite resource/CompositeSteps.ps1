

# Create Composite Directory somewhere in your PSModulePath
New-Item -Path $env:USERPROFILE\Documents\WindowsPowerShell\Modules\WebServerConfig -ItemType Directory -Force

# Create a new Module Manifest. This must match the name of its parent folder
New-ModuleManifest -Path $env:USERPROFILE\Documents\WindowsPowerShell\Modules\WebServerConfig\WebServerConfig.psd1

# Create DSCResources folder under your Composite folder
New-Item -Path $env:USERPROFILE\Documents\WindowsPowerShell\Modules\WebServerConfig\DSCResources -ItemType Directory -Force

# Create a directory under the DSCResources folder
New-Item -Path $env:USERPROFILE\Documents\WindowsPowerShell\Modules\WebServerConfig\DSCResources\WebFeatures -ItemType Directory -Force

# Create Schema file named the same as it's parent folder
New-Item -Path $env:USERPROFILE\Documents\WindowsPowerShell\Modules\WebServerConfig\DSCResources\WebFeatures\WebFeatures.schema.psm1 -ItemType File -Force

# Create Module Manifest file named the same as parent folder and specify the Schema file created in the previous step as the RootModule
New-ModuleManifest -Path $env:USERPROFILE\Documents\WindowsPowerShell\Modules\WebServerConfig\DSCResources\WebFeatures\WebFeatures.psd1 -RootModule .\WebFeatures.schema.psm1

# Open Schema file to add WindowsFeature resources
ise $env:USERPROFILE\Documents\WindowsPowerShell\Modules\WebServerConfig\DSCResources\WebFeatures\WebFeatures.schema.psm1

# Run Get-DSCResource to see the new Composite Resource
Get-DscResource

# New Sample Configuration with Composite
ise .\SampleConfiguration_Composite.ps1




