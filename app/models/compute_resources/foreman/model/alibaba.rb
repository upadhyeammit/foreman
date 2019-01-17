module Foreman::Model
  class ALIBABA < ComputeResource

    #has_one :key_pair, :foreign_key => :compute_resource_id, :dependent => :destroy
    validates :access_key_id, :access_key_secret, :region, :auth_url, :zone, :url, :presence => true

    def self.available?
      Fog::Compute.providers.include?(:google)
    end

    def vms(opts = {})
      client.servers.all
    end

    def self.available?
      Fog::Compute.providers.include?(:aliyun)
    end

    def access_key_id
      attrs[:access_key_id]
    end

    def access_key_id=(name)
      attrs[:access_key_id] = name
    end

    def access_key_secret
      attrs[:access_key_secret]
    end

    def access_key_secret=(name)
      attrs[:access_key_secret] = name
    end

    def region
      attrs[:region]
    end

    def region=(name)
      attrs[:region] = name
    end

    def auth_url
      attrs[:auth_url]
    end

    def auth_url=(name)
      attrs[:auth_url] = name
    end

    def zone
      attrs[:zone]
    end

    def zones
      parse_json(client.list_zones.body, 'Zones', 'ZoneId')
    end

    def zone=(name)
      attrs[:zone] = name
    end

    def url
      attrs[:url]
    end

    def url=(name)
      attrs[:url] = name
    end

    def self.model_name
      ComputeResource.model_name
    end

    def networks
      parse_json(client.list_networks.body, 'Vpcs', 'VpcID')
    end

    def disks
      parse_json(client.list_disks.body, 'Disks', 'DiskId')
    end

    def parse_json(input,para,itr)
      ret_arr = []
      arr = JSON.parse(input)[para].values.reduce
      arr.each {|ele| ret_arr << ele[itr]}
      ret_arr
    end

    def new_volume(attrs = { })
      size = (attrs[:size_gb] || 10)
      args = {:name => attrs[:disk_name], :description => attrs[:disk_description], :category => attrs[:disk_category]}
      client.create_disk(size, args)
    end



    def client
      @client ||= ::Fog::Compute.new(:provider => 'aliyun', :aliyun_accesskey_id => access_key_id, :aliyun_accesskey_secret => access_key_secret, :aliyun_region_id => region, :aliyun_zone_id => zone, :aliyun_url => url)
    end

    def test_connection(options = {})
      super
      #errors[:user].empty? && errors[:password].empty? && zones
        rescue => e
      errors[:base] << e.message
      end

  end
  end
