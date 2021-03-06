class TopicsController < ApplicationController
  before_action :authenticate!, except: :show
  before_action :validate_topic_ownership!, only: [:edit, :update]

  expose(:topic, attributes: :topic_params)
  expose(:events) { Event.with_topics.ordered.page(params[:page]).per(10) }
  expose(:undone_topics) { Topic.ordered.undone }
  expose(:done_topics) { Topic.ordered.done }

  def show; end
  def new; end
  def edit; end

  def create
    topic.label = Whitelabel[:label_id]
    topic.user  = current_user
    if topic.save
      redirect_to(topic_path(topic), notice: t("flash.topic_added"))
    else
      redirect_to(new_topic_path, alert: topic.errors.full_messages.join(', '))
    end
  end

  def update
    if topic.save
      redirect_to(topic_path(topic), notice: t("flash.topic_updated"))
    else
      redirect_to(edit_topic_path, alert: topic.errors.full_messages.join(', '))
    end
  end

  private

  def validate_topic_ownership!
    redirect_to(root_path, alert: t("flash.not_authenticated")) unless topic.user == current_user
  end

  def topic_params
    params.require(:topic).permit(:label, :name, :user, :description)
  end
end
