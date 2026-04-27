# frozen_string_literal: true

class StatisticsCalculator
  QUERY = <<~SQL
    WITH active_checks AS (
      SELECT c.rtt
      FROM checks c
      WHERE c.ip_id = :ip_id
        AND c.created_at BETWEEN :from AND :to
        AND (
          SELECT enabled
          FROM status_logs sl
          WHERE sl.ip_id = c.ip_id AND sl.changed_at <= c.created_at
          ORDER BY sl.changed_at DESC
          LIMIT 1
        ) = true
    )
    SELECT
      AVG(rtt) as avg_rtt,
      MIN(rtt) as min_rtt,
      MAX(rtt) as max_rtt,
      PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY rtt) as median_rtt,
      STDDEV(rtt) as stddev_rtt,
      (COUNT(*) FILTER (WHERE rtt IS NULL)::float / NULLIF(COUNT(*), 0)) * 100 as loss_percent,
      COUNT(*) as total_checks
    FROM active_checks
  SQL

  def self.call(ip, time_from, time_to)
    dataset = DB.connection.fetch(QUERY, ip_id: ip.id, from: time_from, to: time_to)
    result = dataset.first

    return { error: 'No data available for the selected period or IP was inactive' } if result[:total_checks].to_i.zero?

    result
  end
end
