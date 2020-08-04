class OptionsController < ApplicationController
  def index
    # cookies[:option] = nil
    @setoptions = setvalue_check()
    
    if @setoptions[:searchdisplay] == 1 then
      @searchdisplay_check = "checked"
    else
      @searchdisplay_check = ""
    end

    respond_to do |format|
      format.html
      format.json
    end
  end

  def create

    #cookieを設定
    cookiestr = ""
    cookiestr += "searchvalue=#{params[:searchvalue]}&"
    cookiestr += "searchorder=#{params[:searchorder]}&"
    cookiestr += "searchdisplay=#{params[:searchdisplay]}&"
    cookiestr += "displaybgc=#{params[:displaybgc]}&"

    trendsets = ""
    params[:trendsetting].each do |t|
      trendsets += "#{t}|" 
    end
    unless trendsets == "" then
      trendsets = trendsets.chop
    end
    cookiestr += "trendsetting=#{trendsets}"

    cookies[:option] = cookiestr

    #履歴の削除
    if params[:historyempty] == "1" then
      cookies[:history_keyword] = ""
    end

    respond_to do |format|
      format.html { redirect_to options_path }
      format.json
    end
    
  end

  private

end
