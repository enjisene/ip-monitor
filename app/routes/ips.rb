# frozen_string_literal: true

class App
  plugin :json
  plugin :json_parser
  plugin :all_verbs
  plugin :halt

  hash_branch 'ips' do |r|
    r.post true do
      validation = IpContract.new.call(r.params)
      r.halt(422, { errors: validation.errors.to_h }) if validation.failure?

      params = validation.to_h

      DB.connection.transaction do
        ip = Ip.create(
          address: params[:ip],
          enabled: params.fetch(:enabled, true),
          created_at: Time.now
        )

        ip.values
      end
    end

    r.on Integer do |id|
      puts id
      @ip = Ip[id.to_i] or r.halt(404, { error: 'Not found' })

      r.delete do
        DB.connection.transaction do
          @ip.update(enabled: false)
          @ip.add_status_log(enabled: false)
          @ip.delete
        end
        { success: true }
      end

      r.post 'enable' do
        @ip.update(enabled: true)
        @ip.add_status_log(enabled: true)
        { status: 'enabled' }
      end

      r.post 'disable' do
        @ip.update(enabled: false)
        @ip.add_status_log(enabled: false)
        { status: 'disabled' }
      end

      r.get 'stats' do
        time_from = r.params['time_from']
        time_to = r.params['time_to']

        begin
          from = Time.parse(time_from)
          to = Time.parse(time_to)
        rescue StandardError
          r.halt(400, { error: 'Invalid date format' })
        end

        stats = StatisticsCalculator.call(@ip, from, to)

        if stats[:error]
          r.halt(422, stats)
        else
          stats
        end
      end
    end
  end
end
