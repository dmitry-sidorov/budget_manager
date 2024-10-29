defmodule BudgetManagerWeb.Components.Video do
  @moduledoc """
  A customizable video component for Phoenix applications, designed to simplify the
  embedding of HTML5 video elements with support for various configurations.

  This module ensures compatibility with web standards, addressing common issues such
  as CORS when handling video and subtitle files. It provides a robust interface for
  rendering videos with customizable features, including thumbnail images, aspect ratios, and caption styling.

  The component is built to enhance user experience by offering options for caption display
  and responsive design, catering to various screen sizes and user preferences.

  By leveraging this module, developers can efficiently integrate video playback into their
  Phoenix applications while maintaining flexibility in design and functionality.
  """
  use Phoenix.Component
  use Gettext, backend: BudgetManagerWeb.Gettext

  @colors [
    "white",
    "primary",
    "secondary",
    "dark",
    "success",
    "warning",
    "danger",
    "info",
    "light",
    "misc",
    "dawn",
    "silver"
  ]

  # https://stackoverflow.com/questions/15268604/html5-track-captions-not-showing/15268843#15268843
  # https://www.w3schools.com/tags/tag_video.asp

  # Ensure your video and .vtt files are served from the same web server.
  # Browsers may block captions if accessed from the local file system or different servers.
  # Use a local web server for testing to avoid these issues.

  # 1. When you access an HTML file directly from your file system (file:/// protocol),
  #     browsers often have restrictions that prevent the proper functioning of certain features,
  #     including the <track> tag. The captions might not display properly in such cases.

  # 2. The video source and .vtt file should generally be hosted on the same server to avoid cross-origin issues (CORS).
  #     If they are on different servers,
  #     you may need to ensure proper CORS headers are set up to allow the browser to access the caption file.

  # Important:  Adding a Base64-encoded subtitle directly to a video won't cause a CORS issue,
  #             so you can use it in your components even if the subtitle is not from the same origin.

  @doc """
  The `video` component is used to embed a video element with various customization options
  like thumbnail, caption, size, and control settings.

  It supports multiple sources and subtitles.

  ## Examples

  ```elixir
  <div class="space-y-5 max-w-xl mx-auto py-10">
    <.video
      ratio="video"
      caption_bakcground="danger"
      caption_size="quadruple_large"
      thumbnail="https://example.com/uploads/title_anouncement.jpg"
      controls
    >
      <:source
        src="https://example.com/flower.webm"
        type="video/webm"
      />
      <:source
        src="https://example.com/flower.mp4"
        type="video/mp4"
      />
      <:track
        label="English"
        kind="captions"
        srclang="en"
        src="data:text/vtt;base64,V0VCVlRUCgowMDowMDowMC4wMDAgLS0+IDAwOjAwOjAwLjk5OSAgbGluZTo4MCUKSGlsZHkhCgowMDowMDowMS4wMDAgLS0+IDAwOjAwOjAxLjQ5OSBsaW5lOjgwJQpIb3cgYXJlIHlvdT8KCjAwOjAwOjAxLjUwMCAtLT4gMDA6MDA6MDIuOTk5IGxpbmU6ODAlClRlbGwgbWUsIGlzIHRoZSA8dT5sb3JkIG9mIHRoZSB1bml2ZXJzZTwvdT4gaW4/CgowMDowMDowMy4wMDAgLS0+IDAwOjAwOjA0LjI5OSBsaW5lOjgwJQpZZXMsIGhlJ3MgaW4gLSBpbiBhIGJhZCBodW1vcgoKMDA6MDA6MDQuMzAwIC0tPiAwMDowMDowNi4wMDAgbGluZTo4MCUKU29tZWJ5IG11c3QndmUgc3RvbGVuIHRoZSBjcm93biBqZXdlbHMK"
        default
      />
    </.video>
  </div>
  ```
  """
  @doc type: :component
  attr :id, :string,
    default: nil,
    doc: "A unique identifier is used to manage state and interaction"

  attr :thumbnail, :string, default: nil, doc: "Determines thumbnail for video"
  attr :width, :string, default: "full", doc: "Determines the element width"
  attr :rounded, :string, default: "none", doc: "Determines the border radius"
  attr :height, :string, default: "auto", doc: "Determines the element width"
  attr :caption_size, :string, default: "extra_small", doc: "Determines the video caption size"

  attr :caption_bakcground, :string,
    values: @colors,
    default: "dark",
    doc: "Determines the video caption bakcground"

  attr :caption_opacity, :string, default: "solid", doc: "Determines the video caption opacity"
  attr :ratio, :string, default: "auto", doc: "Determines the video ratio"
  attr :class, :string, default: nil, doc: "Custom CSS class for additional styling"

  attr :rest, :global,
    include: ~w(controls autoplay loop muted preload),
    doc:
      "Global attributes can define defaults which are merged with attributes provided by the caller"

  slot :source, required: true, doc: "Determines media source" do
    attr :src, :string, required: true, doc: "Media link"
    attr :type, :string, required: true, doc: "Media type"
  end

  slot :track, required: false, doc: "Determines media subtitle" do
    attr :src, :string, required: true, doc: "Subtitle link"
    attr :label, :string, doc: "Subtitle Lable"
    attr :kind, :string, doc: "Subtitle Kind"
    attr :srclang, :string, doc: "Subtitle language link or symbol"
    attr :default, :boolean, doc: "Determines whether this subtitle is default"
  end

  def video(assigns) do
    ~H"""
    <video
      id={@id}
      class={[
        width_class(@width),
        height_class(@height),
        rounded_size(@rounded),
        aspect_ratio(@ratio),
        caption_size(@caption_size),
        caption_bakcground(@caption_bakcground),
        caption_opacity(@caption_opacity),
        @class
      ]}
      poster={@thumbnail}
      {@rest}
    >
      <source :for={source <- @source} src={source.src} type={source.type} />

      <track
        :for={track <- @track}
        src={track.src}
        label={track.label || "English"}
        kind={track.kind || "subtitles"}
        srclang={track.srclang || "en"}
        default={track.default}
      />

      <%= gettext("Your browser does not support the video tag.") %>
    </video>
    """
  end

  defp width_class("extra_small"), do: "w-3/12"
  defp width_class("small"), do: "w-5/12"
  defp width_class("medium"), do: "w-6/12"
  defp width_class("large"), do: "w-9/12"
  defp width_class("extra_large"), do: "w-11/12"
  defp width_class("full"), do: "w-full"
  defp width_class(params) when is_binary(params), do: params
  defp width_class(_), do: width_class("full")

  defp height_class("extra_small"), do: "h-60"
  defp height_class("small"), do: "h-64"
  defp height_class("medium"), do: "h-72"
  defp height_class("large"), do: "h-80"
  defp height_class("extra_large"), do: "h-96"
  defp height_class("auto"), do: "h-auto"
  defp height_class(params) when is_binary(params), do: params
  defp height_class(_), do: height_class("auto")

  defp aspect_ratio("auto"), do: "aspect-auto"
  defp aspect_ratio("square"), do: "aspect-square"
  defp aspect_ratio("video"), do: "aspect-video"
  defp aspect_ratio("4:3"), do: "aspect-[4/3]"
  defp aspect_ratio("3:2"), do: "aspect-[3/2]"
  defp aspect_ratio("21:9"), do: "aspect-[21/9]"
  defp aspect_ratio(params) when is_binary(params), do: params
  defp aspect_ratio(_), do: aspect_ratio("video")

  defp rounded_size("extra_small"), do: "rounded-sm"

  defp rounded_size("small"), do: "rounded"

  defp rounded_size("medium"), do: "rounded-md"

  defp rounded_size("large"), do: "rounded-lg"

  defp rounded_size("extra_large"), do: "rounded-xl"

  defp rounded_size("none"), do: "rounded-none"
  defp rounded_size(_), do: rounded_size("none")

  defp caption_size("extra_small"), do: "[&::cue]:text-xs"
  defp caption_size("small"), do: "[&::cue]:text-sm"
  defp caption_size("medium"), do: "[&::cue]:text-base"
  defp caption_size("large"), do: "[&::cue]:text-lg"
  defp caption_size("extra_large"), do: "[&::cue]:text-xl"
  defp caption_size("double_large"), do: "[&::cue]:text-2xl"
  defp caption_size("triple_large"), do: "[&::cue]:text-3xl"
  defp caption_size("quadruple_large"), do: "[&::cue]:text-4xl"
  defp caption_size(params) when is_binary(params), do: params
  defp caption_size(_), do: caption_size("extra_small")

  defp caption_bakcground("white"),
    do: "[&::cue]:bg-[linear-gradient(#fff,#fff)] [&::cue]:text-[#1E1E1E]"

  defp caption_bakcground("primary"),
    do: "[&::cue]:bg-[linear-gradient(#2441de,#2441de)] [&::cue]:text-white"

  defp caption_bakcground("secondary"),
    do: "[&::cue]:bg-[linear-gradient(#877C7C,#877C7C)] [&::cue]:text-white"

  defp caption_bakcground("success"),
    do: "[&::cue]:bg-[linear-gradient(#6EE7B7,#6EE7B7)] [&::cue]:text-[#1E1E1E]"

  defp caption_bakcground("warning"),
    do: "[&::cue]:bg-[linear-gradient(#FF8B08,#FF8B08)] [&::cue]:text-[#1E1E1E]"

  defp caption_bakcground("danger"),
    do: "[&::cue]:bg-[linear-gradient(#E73B3B,#E73B3B)] [&::cue]:text-[#1E1E1E]"

  defp caption_bakcground("info"),
    do: "[&::cue]:bg-[linear-gradient(#004FC4,#004FC4)] [&::cue]:text-[#1E1E1E]"

  defp caption_bakcground("misc"),
    do: "[&::cue]:bg-[linear-gradient(#52059C,#52059C)] [&::cue]:text-[#1E1E1E]"

  defp caption_bakcground("dawn"),
    do: "[&::cue]:bg-[linear-gradient(#4D4137,#4D4137)] [&::cue]:text-[#1E1E1E]"

  defp caption_bakcground("light"),
    do: "[&::cue]:bg-[linear-gradient(#707483,#707483)] [&::cue]:text-[#1E1E1E]"

  defp caption_bakcground("dark"),
    do: "[&::cue]:bg-[linear-gradient(#1E1E1E,#1E1E1E)] [&::cue]:text-white"

  defp caption_bakcground(params) when is_binary(params), do: params
  defp caption_bakcground(_), do: caption_bakcground("white")

  defp caption_opacity("transparent") do
    "[&::cue]:bg-opacity-10"
  end

  defp caption_opacity("translucent") do
    "bg-opacity-20"
  end

  defp caption_opacity("semi_transparent") do
    "[&::cue]:bg-opacity-30"
  end

  defp caption_opacity("lightly_tinted") do
    "[&::cue]:bg-opacity-40"
  end

  defp caption_opacity("tinted") do
    "[&::cue]:bg-opacity-50"
  end

  defp caption_opacity("semi_opaque") do
    "[&::cue]:bg-opacity-60"
  end

  defp caption_opacity("opaque") do
    "[&::cue]:bg-opacity-70"
  end

  defp caption_opacity("heavily_tinted") do
    "[&::cue]:bg-opacity-80"
  end

  defp caption_opacity("almost_solid") do
    "[&::cue]:bg-opacity-90"
  end

  defp caption_opacity("solid") do
    "[&::cue]:bg-opacity-100"
  end

  defp caption_opacity(params) when is_binary(params), do: params
  defp caption_opacity(_), do: caption_opacity("solid")
end