require 'rails_helper'

RSpec.describe NotamsController, type: :controller do

  describe "GET #create" do
    it "returns http success" do
      get :upload
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    it "success with correct data" do
      post :show, data: "B0519/15 NOTAMN\nQ) ESAA/QFAAH/IV/NBO/A /000/999/5746N01404E005\nA) ESGJ B) 1502271138 C) 1503012359\nE) AERODROME HOURS OF OPS/SERVICE MON-WED 0500-1830 THU 0500-2130\nFRI\n0730-2100 SAT 0630-0730, 1900-2100 SUN CLOSED\nCREATED: 27 Feb 2015 11:40:00\nSOURCE: EUECYIYN\n"
      expect(assigns[:aerodomes]).to have_key('ESGJ')
      expect(response).to have_http_status(:success)
    end

    it "success with multiple notams" do
      post :show, data: <<-EOF
B0513/15 NOTAMN
Q) ESAA/QFAAH/IV/NBO/A /000/999/6232N01727E005
A) ESNN B) 1503090000 C) 1503292359
E) AERODROME HOURS OF OPS/SERVICE
MON 0445-2115 TUE 0500-2130 WED-THU 0500-2300 FRI 0500-2115 SAT
0715-1300 SUN 1115-2145
CREATED: 27 Feb 2015 10:48:00
SOURCE: EUECYIYN

B0451/15 NOTAMN
Q) ESAA/QFAAH/IV/NBO/A /000/999/6324N01900E005
A) ESNO B) 1503090000 C) 1503292359
E) AERODROME HOURS OF OPS/SERVICE:MON-WED 0430-2130 THU 0430-2215
FRI 0445-2130 SAT CLSD SUN 1030-1900
CREATED: 22 Feb 2015 13:17:00
SOURCE: EUECYIYN

      EOF
      expect(assigns[:aerodomes].keys).to include('ESNN', 'ESNO')
    end

    it "success with snowtam" do
      post :show, data: "SWES0196 ESSV 02271450\n(SNOWTAM 0196\nA)ESSV\nB)02271450\nC)03 F)NIL/NIL/NIL)\nCREATED: 27 Feb 2015 15:05:00\nSOURCE: EUECYIYN\n"
      expect(assigns[:aerodomes]).to be_empty
    end
  end

end
