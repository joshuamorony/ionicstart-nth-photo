package io.ionic.starter;
import android.database.Cursor;
import android.provider.MediaStore;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

@CapacitorPlugin(name = "NthPhotoPlugin")
public class NthPhotoPlugin extends Plugin {
  @PluginMethod
  public void getNthPhoto(PluginCall call) {

    int photoAt = Integer.parseInt(call.getString("photoAt"));

    //final String[] imageColumns = { MediaStore.Images.Media._ID, MediaStore.Images.Media.DATA };
    //final String imageOrderBy = MediaStore.Images.Media._ID + " DESC";
    Cursor imageCursor = getActivity().getContentResolver().query(MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
      null,
      null,
      null,
      MediaStore.Images.Media.DATA + " DESC"
    );
    imageCursor.moveToFirst();
    int found = 0;
    String latest = "";
    if(imageCursor.getCount() > 0){
      do {
        int index = imageCursor.getColumnIndex(MediaStore.Images.Media.DATA);
        if(index > -1){
          String fullPath = imageCursor.getString(index);
          if (fullPath.contains("DCIM")) {
            latest = fullPath;
            found++;
          }
        }

      }
      while (imageCursor.moveToNext() && found < photoAt);
    } else {
      call.reject("No images");
    }


    JSObject ret = new JSObject();
    ret.put("image", latest);
    call.resolve(ret);

  }
}
