# Nike Album Viewer

**Data**

I used a simple URLSession to fetch the JSON and Swift Decodable to consume it. I used asynchronous URLSessions to fetch the artwork and populate the image views in the table as the images come in. 

**Layout**

I decided to use a split view controller because the implementation of the intitial table view is exactly the same as not using one. We get a lot of rotation and iPad functionality for free. I used an un-editable text view on the detail view to handle scrolling. This is an unusual choice but it easily accommodated different screen and text sizes without haveing to use a scrollView. 

**Extras**

It supports dynamic type, all device sizes, and rotation. It's not pretty when you set your font to maximum size, but it all works. I added a drop shadow to the imageViews so the edges are visilbe for mostly white art on the white background. I used a unit test verify the JSON decoding. Writing the test first really helped in this case.    

**Caveats** 

It's always difficult to decide how thorough to be on coding tests. I took a lot of shortcuts that I would not take in a production app. Static strings are sprinkled through the app and not localized. Error handling is very rudimentary, especially
in the networking code. There is no real image cacheing. I noted in comments where I would improve things. I did what I think is reasonable to do in “a few hours”.  