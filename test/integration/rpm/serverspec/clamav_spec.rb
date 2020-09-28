require 'serverspec'

set :backend, :exec

describe package('clamav') do
  it { should be_installed }
end

describe service('freshclam') do
  it { should be_enabled }
end
