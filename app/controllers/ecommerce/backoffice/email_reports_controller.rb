require_dependency "ecommerce/application_controller"

module Ecommerce
  class Backoffice::EmailReportsController < Backoffice::BaseController
    skip_authorization_check

    DEFAULT_RANGE_DAYS = 30

    def index
      @from     = parse_date(params[:from]) || DEFAULT_RANGE_DAYS.days.ago.beginning_of_day
      @to       = parse_date(params[:to])&.end_of_day || Time.current
      @category = params[:category].presence

      sends = Ecommerce::EmailSend.where(sent_at: @from..@to)
      if @category.present? && Ecommerce::EmailSend::CATEGORIES.include?(@category)
        sends = sends.where(category: @category)
      end

      @total_sends        = sends.count
      @total_opens        = sends.sum(:opens_count)
      @total_clicks       = sends.sum(:clicks_count)
      @unique_opens       = sends.where.not(first_opened_at: nil).count
      @unique_clicks      = sends.where.not(first_clicked_at: nil).count
      @open_rate          = percent(@unique_opens, @total_sends)
      @click_rate         = percent(@unique_clicks, @total_sends)
      @click_to_open_rate = percent(@unique_clicks, @unique_opens)

      @breakdown = sends
        .group(:category, :subtype)
        .pluck(
          :category,
          :subtype,
          Arel.sql("COUNT(*)"),
          Arel.sql("SUM(opens_count)"),
          Arel.sql("SUM(clicks_count)"),
          Arel.sql("SUM(CASE WHEN first_opened_at IS NOT NULL THEN 1 ELSE 0 END)"),
          Arel.sql("SUM(CASE WHEN first_clicked_at IS NOT NULL THEN 1 ELSE 0 END)")
        )
        .map do |category, subtype, sends_count, opens, clicks, unique_opens, unique_clicks|
          {
            category:       category,
            subtype:        subtype,
            sends:          sends_count.to_i,
            opens:          opens.to_i,
            clicks:         clicks.to_i,
            unique_opens:   unique_opens.to_i,
            unique_clicks:  unique_clicks.to_i,
            open_rate:      percent(unique_opens.to_i, sends_count.to_i),
            click_rate:     percent(unique_clicks.to_i, sends_count.to_i)
          }
        end
        .sort_by { |row| -row[:sends] }

      @recent_sends = sends.order(sent_at: :desc).page(params[:page]).per(50)
    end

    private

    def parse_date(value)
      return nil if value.blank?
      Date.parse(value.to_s).to_time
    rescue ArgumentError
      nil
    end

    def percent(numerator, denominator)
      return 0.0 if denominator.to_i.zero?
      ((numerator.to_f / denominator) * 100).round(2)
    end
  end
end
