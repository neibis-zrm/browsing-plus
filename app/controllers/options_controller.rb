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
    cookiestr += "displaybgc=#{params[:displaybgc]}"

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

  def setvalue_check()
    #設定値なしの場合は初期値を作成
    if cookies[:option] == nil then
      cookies[:option] = "searchvalue=10&searchorder=1&searchdisplay=1&displaybgc=1"
    end

    #初期化
    setoptions = {searchvalue: 10, searchorder: 1, searchdisplay: 1,displaybgc: 1}

    #分解
    begin      
      cookies[:option].split("&").each do |optionname|
        if optionname.split("=")[0] == "searchvalue"
          setoptions[:searchvalue] = optionname.split("=")[1].to_i
        end
        if optionname.split("=")[0] == "searchorder"
          setoptions[:searchorder] = optionname.split("=")[1].to_i
        end
        if optionname.split("=")[0] == "searchdisplay"
          setoptions[:searchdisplay] = optionname.split("=")[1].to_i
        end
        if optionname.split("=")[0] == "displaybgc"
          setoptions[:displaybgc] = optionname.split("=")[1].to_i
        end
      end
    rescue => exception
      logger.debug(exception)
    end

    return setoptions

  end
end
