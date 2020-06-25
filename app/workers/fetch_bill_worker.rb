# frozen_string_literal: true

class FetchBillWorker
  include Sidekiq::Worker

  def perform
    FetchBill.call
  end
end
