module SocialHelper
  
  def sign_in_button_for(provider)
    #build on work from http://www.mattboldt.com/demos/social-buttons/
    html=<<HTML
   <a href="#{user_omniauth_authorize_path(provider,params: {})}" class="sc-btn sc--#{provider} mdl-button">
     <span class="sc-icon" id="#{provider}_icon">
       <svg viewBox="#{PROVIDER_BUTTONS[provider][:svg_view_box]}" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
         <g><path d="#{PROVIDER_BUTTONS[provider][:svg_path]}"></path></g>
       </svg>
     </span>
     <span class="sc-text">#{PROVIDER_BUTTONS[provider][:text]}</span>
   </a>
HTML
    html.html_safe
  end

  #paths are from www.mattboldt.com/demos/social-buttons/ 
  #LinkedIn path from http://www.flaticon.com/free-icon/linkedin-logo_34227   CREDITS: Icon made by SimpleIcon .
  PROVIDER_BUTTONS={
  	google: {text: 'Google+', svg_view_box: "0 0 33 33", svg_path: 'M 17.471,2c0,0-6.28,0-8.373,0C 5.344,2, 1.811,4.844, 1.811,8.138c0,3.366, 2.559,6.083, 6.378,6.083 c 0.266,0, 0.524-0.005, 0.776-0.024c-0.248,0.475-0.425,1.009-0.425,1.564c0,0.936, 0.503,1.694, 1.14,2.313 c-0.481,0-0.945,0.014-1.452,0.014C 3.579,18.089,0,21.050,0,24.121c0,3.024, 3.923,4.916, 8.573,4.916 c 5.301,0, 8.228-3.008, 8.228-6.032c0-2.425-0.716-3.877-2.928-5.442c-0.757-0.536-2.204-1.839-2.204-2.604 c0-0.897, 0.256-1.34, 1.607-2.395c 1.385-1.082, 2.365-2.603, 2.365-4.372c0-2.106-0.938-4.159-2.699-4.837l 2.655,0 L 17.471,2z M 14.546,22.483c 0.066,0.28, 0.103,0.569, 0.103,0.863c0,2.444-1.575,4.353-6.093,4.353 c-3.214,0-5.535-2.034-5.535-4.478c0-2.395, 2.879-4.389, 6.093-4.354c 0.75,0.008, 1.449,0.129, 2.083,0.334 C 12.942,20.415, 14.193,21.101, 14.546,22.483z M 9.401,13.368c-2.157-0.065-4.207-2.413-4.58-5.246 c-0.372-2.833, 1.074-5.001, 3.231-4.937c 2.157,0.065, 4.207,2.338, 4.58,5.171 C 13.004,11.189, 11.557,13.433, 9.401,13.368zM 26,8L 26,2L 24,2L 24,8L 18,8L 18,10L 24,10L 24,16L 26,16L 26,10L 32,10L 32,8 z'},
    facebook:  {text: 'Facebook', svg_view_box: "0 0 33 33",  svg_path: 'M 17.996,32L 12,32 L 12,16 l-4,0 l0-5.514 l 4-0.002l-0.006-3.248C 11.993,2.737, 13.213,0, 18.512,0l 4.412,0 l0,5.515 l-2.757,0 c-2.063,0-2.163,0.77-2.163,2.209l-0.008,2.76l 4.959,0 l-0.585,5.514L 18,16L 17.996,32z'},
    twitter:  {text: 'Twitter', svg_view_box: "0 0 33 33",  svg_path: 'M 32,6.076c-1.177,0.522-2.443,0.875-3.771,1.034c 1.355-0.813, 2.396-2.099, 2.887-3.632 c-1.269,0.752-2.674,1.299-4.169,1.593c-1.198-1.276-2.904-2.073-4.792-2.073c-3.626,0-6.565,2.939-6.565,6.565 c0,0.515, 0.058,1.016, 0.17,1.496c-5.456-0.274-10.294-2.888-13.532-6.86c-0.565,0.97-0.889,2.097-0.889,3.301 c0,2.278, 1.159,4.287, 2.921,5.465c-1.076-0.034-2.088-0.329-2.974-0.821c-0.001,0.027-0.001,0.055-0.001,0.083 c0,3.181, 2.263,5.834, 5.266,6.438c-0.551,0.15-1.131,0.23-1.73,0.23c-0.423,0-0.834-0.041-1.235-0.118 c 0.836,2.608, 3.26,4.506, 6.133,4.559c-2.247,1.761-5.078,2.81-8.154,2.81c-0.53,0-1.052-0.031-1.566-0.092 c 2.905,1.863, 6.356,2.95, 10.064,2.95c 12.076,0, 18.679-10.004, 18.679-18.68c0-0.285-0.006-0.568-0.019-0.849 C 30.007,8.548, 31.12,7.392, 32,6.076z'},
    github:  {text: 'GitHub', svg_view_box: "0 0 33 33",  svg_path: 'M 16,0C 7.163,0,0,7.163,0,16s 7.163,16, 16,16s 16-7.163, 16-16S 24.837,0, 16,0z M 25.502,25.502 c-1.235,1.235-2.672,2.204-4.272,2.881c-0.406,0.172-0.819,0.323-1.238,0.453L 19.992,26.438 c0-1.26-0.432-2.188-1.297-2.781 c 0.542-0.052, 1.039-0.125, 1.492-0.219s 0.932-0.229, 1.438-0.406s 0.958-0.388, 1.359-0.633s 0.786-0.563, 1.156-0.953s 0.68-0.833, 0.93-1.328 s 0.448-1.089, 0.594-1.781s 0.219-1.456, 0.219-2.289c0-1.615-0.526-2.99-1.578-4.125c 0.479-1.25, 0.427-2.609-0.156-4.078l-0.391-0.047 c-0.271-0.031-0.758,0.083-1.461,0.344s-1.492,0.688-2.367,1.281c-1.24-0.344-2.526-0.516-3.859-0.516c-1.344,0-2.625,0.172-3.844,0.516 c-0.552-0.375-1.075-0.685-1.57-0.93c-0.495-0.245-0.891-0.411-1.188-0.5s-0.573-0.143-0.828-0.164s-0.419-0.026-0.492-0.016 s-0.125,0.021-0.156,0.031c-0.583,1.479-0.635,2.839-0.156,4.078c-1.052,1.135-1.578,2.51-1.578,4.125c0,0.833, 0.073,1.596, 0.219,2.289 s 0.344,1.286, 0.594,1.781s 0.56,0.938, 0.93,1.328s 0.755,0.708, 1.156,0.953s 0.854,0.456, 1.359,0.633s 0.984,0.313, 1.438,0.406 s 0.951,0.167, 1.492,0.219c-0.854,0.583-1.281,1.51-1.281,2.781l0,2.445 c-0.472-0.14-0.937-0.306-1.394-0.5 c-1.6-0.677-3.037-1.646-4.272-2.881c-1.235-1.235-2.204-2.672-2.881-4.272C 2.917,19.575, 2.563,17.815, 2.563,16 s 0.355-3.575, 1.055-5.23c 0.677-1.6, 1.646-3.037, 2.881-4.272s 2.672-2.204, 4.272-2.881 C 12.425,2.917, 14.185,2.563, 16,2.563s 3.575,0.355, 5.23,1.055c 1.6,0.677, 3.037,1.646, 4.272,2.881 c 1.235,1.235, 2.204,2.672, 2.881,4.272C 29.083,12.425, 29.438,14.185, 29.438,16s-0.355,3.575-1.055,5.23 C 27.706,22.829, 26.737,24.267, 25.502,25.502z'},
    linkedin:  {text: 'Linked In', svg_view_box: "0 0 450 450",  svg_path: "M430.117,261.543V420.56h-92.188V272.193c0-37.271-13.334-62.707-46.703-62.707 c-25.473,0-40.632,17.142-47.301,33.724c-2.432,5.928-3.058,14.179-3.058,22.477V420.56h-92.219c0,0,1.242-251.285,0-277.32h92.21 v39.309c-0.187,0.294-0.43,0.611-0.606,0.896h0.606v-0.896c12.251-18.869,34.13-45.824,83.102-45.824 C384.633,136.724,430.117,176.361,430.117,261.543z M52.183,9.558C20.635,9.558,0,30.251,0,57.463 c0,26.619,20.038,47.94,50.959,47.94h0.616c32.159,0,52.159-21.317,52.159-47.94C103.128,30.251,83.734,9.558,52.183,9.558z M5.477,420.56h92.184v-277.32H5.477V420.56z"}
  }
end
