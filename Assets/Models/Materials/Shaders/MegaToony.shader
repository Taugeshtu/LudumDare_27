Shader "Tau/MegaToony" {
	Properties {
		_Color ("Main Color", Color) = (0.5,0.5,0.5,1)
		_MainTex ("Texture", 2D) = "white" {}
		_Ramp ("Toon Ramp (RGB)", 2D) = "gray" {}
		_Distortion ("Lighting distortion", float) = 0.1
	}
	SubShader {
		Tags { "RenderType" = "Opaque" }
		CGPROGRAM
		#pragma surface surf ToonRamp
		sampler2D _Ramp;
		float _Distortion;
		#pragma lighting ToonRamp exclude_path:prepass
		inline half4 LightingToonRamp (SurfaceOutput s, half3 lightDir, half atten)
		{
			#ifndef USING_DIRECTIONAL_LIGHT
			lightDir = normalize(lightDir);
			#endif
			
			half d = dot (s.Normal, lightDir)*0.5 + 0.5 + s.Alpha *_Distortion - _Distortion*0.5;
			half3 ramp = tex2D (_Ramp, float2(d,d)).rgb;
			
			half4 c;
			c.rgb = s.Albedo *_LightColor0.rgb *ramp *(atten *2) + floor(ramp +0.0001);
			c.a = 0;
			return c;
		}
		struct Input {
			float3 worldPos;	// could be used for 3-dimensional light brushing
		};
		sampler2D _MainTex;
		float4 _Color;
		void surf (Input IN, inout SurfaceOutput o) {
			o.Albedo = _Color;
			
			float2 screenUV = IN.worldPos.xz;
			screenUV.x += IN.worldPos.y *0.5;
			screenUV.y += IN.worldPos.y *0.5;
			screenUV *= 0.1;
			o.Alpha = tex2D (_MainTex, screenUV).r * 2;
		}
		ENDCG
	}
	Fallback "Diffuse"
}