let normal =
  let pi = 4. *. atan 1. in
  let saved = ref None in
  fun st ->
    match !saved with
    | Some (r, t) ->
        saved := None ;
        r *. sin t
    | None ->
        let u1 = Random.State.float st 1. in
        let u2 = Random.State.float st 1. in
        let r = sqrt (-2. *. log u1) in
        let t = 2. *. pi *. u2 in
        saved := Some (r, t) ;
        r *. cos t

let normal2 (mu_x, mu_y) st = Plot.r2 (normal st +. mu_x) (normal st +. mu_y)

let normal3 (mu_x, mu_y, mu_z) st =
  Plot.r3 (normal st +. mu_x) (normal st +. mu_y) (normal st +. mu_z)

let scatter ~mu st =
  Plot.Scatter.points_2d
    ~points:(Plot.Data.of_array (Array.init 100 (fun _ -> normal2 mu st)))
    ()

let st = Random.State.make_self_init ()

let scatter2d_example =
  Plot.plot2
    ~xaxis:"x"
    ~yaxis:"y"
    ~title:"Clouds"
    [scatter ~mu:(3., 2.) st; scatter ~mu:(10., 8.) st]

let () =
  let target = Plot.png ~pixel_size:(1024, 1024) ~png_file:"scatter.png" () in
  Plot.(run ~target exec scatter2d_example)

let discretize f =
  Array.init 100 (fun i ->
      let x = float_of_int i *. 0.1 in
      Plot.r2 x (f x))

let sine_with_points =
  let open Plot in
  Line.line_2d
    ~points:(Data.of_array (discretize sin))
    ~style:
      Style.(default |> set_color Color.red |> set_point ~ptyp:Pointtype.box)
    ~with_points:true
    ~legend:"sin"
    ()

let line2d_example =
  let open Plot.Tics in
  let tics = default |> set_position ~start:~-.1. ~incr:0.5 in
  let xtics = tics in
  let ytics = tics |> set_rotate ~degrees:90. in
  Plot.plot2
    ~xaxis:"x"
    ~yaxis:"y"
    ~xtics
    ~ytics
    ~title:"Lines"
    [sine_with_points]

let () =
  let target = Plot.png ~pixel_size:(1024, 1024) ~png_file:"line.png" () in
  Plot.(run ~target exec line2d_example)

let line2d_example_setrange =
  let open Plot.Tics in
  let tics = default |> set_position ~start:~-.1. ~incr:0.5 in
  let xtics = tics in
  let ytics = tics |> set_rotate ~degrees:90. in
  Plot.plot2
    ~xaxis:"x"
    ~yaxis:"y"
    ~xtics
    ~ytics
    ~yrange:(Plot.Range.make ~min:0.0 ~max:0.5 ())
    ~title:"Lines"
    [sine_with_points]

let () =
  let target =
    Plot.png ~pixel_size:(1024, 1024) ~png_file:"line_setrange.png" ()
  in
  Plot.(run ~target exec line2d_example_setrange)

let gaussian =
  let open Plot in
  Histogram.hist
    ~points:(Data.of_array (Array.init 100 (fun _ -> r1 @@ normal st)))
    ()

let histogram_example =
  Plot.plot2 ~xaxis:"x" ~yaxis:"freq" ~title:"Histogram" [gaussian]

let () =
  let target = Plot.png ~pixel_size:(1024, 1024) ~png_file:"histogram.png" () in
  Plot.(run ~target exec histogram_example)

let test =
  let open Plot in
  Bar.simple (Data.of_list [("a", 1.); ("b", 2.); ("c", 3.); ("d", -1.)]) ()

let box_example = Plot.plot2 ~xaxis:"x" ~yaxis:"freq" ~title:"boxes" [test]

let () =
  let target = Plot.png ~pixel_size:(1024, 1024) ~png_file:"boxes.png" () in
  Plot.(run ~target exec box_example)

let circle_2d_example =
  let open Plot in
  plot2
    ~xaxis:"x"
    ~yaxis:"y"
    ~title:"2d circles"
    [ Circle.circle_2d
        ~points:(Data.of_list [r3 1. 1. 1.; r3 3. 1. 1.5; r3 5. 1. 3.0])
        ~fill:
          Fill.(
            default
            |> set_solid ~density:0.2 ~transparent:true
            |> set_color Color.red)
        () ]

let () =
  let target = Plot.png ~pixel_size:(1024, 1024) ~png_file:"circles2d.png" () in
  Plot.(run ~target exec circle_2d_example)

let circle_3d_example =
  let open Plot in
  plot3
    ~xaxis:"x"
    ~yaxis:"y"
    ~zaxis:"z"
    ~title:"3d circles"
    [ Circle.circle_3d
        ~points:
          (Data.of_list [r4 1. 1. 1. 1.; r4 10. 10. 10. 1.5; r4 5. 12. 1. 3.0])
        () ]

let () =
  let target = Plot.png ~pixel_size:(1024, 1024) ~png_file:"circles3d.png" () in
  Plot.(run ~target exec circle_3d_example)

let _ =
  match Plot.get_targets () with
  | None -> assert false
  | Some strs -> List.iter (fun x -> Format.printf "%s@." x) strs
