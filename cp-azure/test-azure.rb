require 'chef/provisioning/azure_driver'
with_driver 'azure'

machine_name = 'jcheng-test998'
vm_size = 'ExtraSmall'
location = 'West US'

machine_options = {
 :bootstrap_options => {
 :cloud_service_name => machine_name,
 :storage_account_name => 'jchengtest998',
 :vm_size => vm_size,
 :location => location
 },
 # Until SSH keys are supported (soon)
 :password => "#{ENV['CP_AZURE_DEFAULT_PASSWORD']}"
}

machine machine_name do
 machine_options machine_options
end
