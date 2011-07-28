from bpy import context

filename = "/home/bmonkey/workspace/hiwi/baselibAppBuild/data/muenzplatz_path1.txt"

scene = context.scene

f = open(filename, 'w')
f.write("#position X Y Z, rotation 3x3\n\n")

for frame in range(scene.frame_start, scene.frame_end+scene.frame_step, scene.frame_step):
    scene.frame_set(frame)
    context.scene.update()
    camera = scene.camera
    rotation = context.scene.camera.rotation_axis_angle.id_data.matrix_world.to_3x3()
    position = context.scene.camera.location
    cameraproperties = "%f %f %f %f %f %f %f %f %f %f %f %f\n" % (position.x, position.y, position.z, rotation[0].x, rotation[0].y, rotation[0].z, rotation[1].x, rotation[1].y, rotation[1].z, rotation[2].x, rotation[2].y, rotation[2].z)
    f.write(cameraproperties)

f.close()