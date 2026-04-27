# frozen_string_literal: true

# db/migrations/001_create_base_schema.rb
Sequel.migration do
  change do
    create_table(:ips) do
      primary_key :id
      column :address, :inet, null: false, unique: true
      column :enabled, :boolean, default: true, null: false
      column :created_at, :timestamp, null: false
      column :updated_at, :timestamp
    end

    create_table(:status_logs) do
      primary_key :id
      foreign_key :ip_id, :ips, on_delete: :cascade
      column :enabled, :boolean, null: false
      column :changed_at, :timestamp, default: Sequel::CURRENT_TIMESTAMP, null: false
    end

    # Результаты проверок (пинг)
    create_table(:checks) do
      primary_key :id
      foreign_key :ip_id, :ips, on_delete: :cascade
      column :rtt, :float
      column :created_at, :timestamp, default: Sequel::CURRENT_TIMESTAMP, null: false

      index %i[ip_id created_at]
    end
  end
end
