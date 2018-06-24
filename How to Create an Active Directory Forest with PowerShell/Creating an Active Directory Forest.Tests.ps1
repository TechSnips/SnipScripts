describe 'Active Directory Forest' {

	BeforeAll {
		$domainCred = Import-Clixml -Path C:\PowerLab\DomainCredential.xml
		$session = New-PSSession -VMName 'LABDC' -Credential $domainCred

		$adobjectSpreadsheetPath = 'C:\Automate-The-Boring-Stuff-With-PowerShell\Part II\Creating an Active Directory Forest\ActiveDirectoryObjects.xlsx'
		$expectedUsers = Import-Excel -Path $adobjectSpreadsheetPath -WorksheetName Users
		$expectedGroups = Import-Excel -Path $adobjectSpreadsheetPath -WorksheetName Groups
	}

	AfterAll {
		$session | Remove-PSSession
	}

	context 'Domain' {
		$domain = Invoke-Command -Session $session -ScriptBlock { Get-AdDomain }
		$forest = Invoke-Command -Session $session -ScriptBlock { Get-AdForest }

		it "the domain mode should be Windows2016Domain" {
			$domain.DomainMode | should be 'Windows2016Domain'
		}

		it "the forest mode should be WinThreshold" {
			$forest.ForestMode | should be 'Windows2016Forest'
		}

		it "the domain name should be powerlab.local" {
			$domain.Name | should be 'powerlab'
		}
	}

	context 'Organizational Units' {

		$allOus = ($expectedUsers.OUName + $expectedGroups.OUName) | Select-Object -Unique
		foreach ($ou in $allOus) {
			it "the OU [$ou] should exist" {
				Invoke-Command -Session $session -ScriptBlock { Get-AdOrganizationalUnit -Filter "Name -eq '$using:ou'" } | should not benullorempty
			}
		}
	}

	context 'Users' {
		foreach ($user in $expectedUsers) {
			$actualUser = Invoke-Command -Session $session -ScriptBlock { Get-AdUser -Filter "Name -eq '$($using:user.UserName)'" }
			it "the user [$($user.UserName)] should exist" {
				$actualUser | should not benullorempty
			}
			it "the user [$($user.UserName)] should be in the [$($user.OUName)] OU" {
				($actualUser.DistinguishedName -replace "CN=$($user.UserName),") | should be "OU=$($user.OUName),DC=powerlab,DC=local"
			}
			it "the user [$($user.UserName)] should be in the [$($user.MemberOf)] group" {
				$groupMembers = Invoke-Command -Session $session -ScriptBlock { (Get-AdGroupMember -Identity $using:user.MemberOf).Name }
				$groupMembers -eq $user.UserName | should not benullorempty
			}
		}
	}

	context 'Groups' {
		foreach ($group in $expectedGroups) {
			$actualGroup = Invoke-Command -Session $session -ScriptBlock { Get-AdGroup -Filter "Name -eq '$($using:group.GroupName)'" }
			it "the group [$($group.GroupName)] should exist" {
				$actualGroup | should not benullorempty
			}
			it "the group [$($group.GroupName)] should be in the [$($group.OUName)] OU" {
				($actualGroup.DistinguishedName -replace "CN=$($group.GroupName),") | should be "OU=$($group.OUName),DC=powerlab,DC=local"
			}
		}
	}
}