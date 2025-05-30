package com.example.finsplore.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

public class BasiqAuthLinkResponse {
    private Links links;

    public Links getLinks() {
        return links;
    }

    public void setLinks(Links links) {
        this.links = links;
    }

    public static class Links {
        private String _public;

        @JsonProperty("public")  // 映射 JSON 字段名 "public" 到变量 _public
        public String getPublic() {
            return _public;
        }

        public void setPublic(String _public) {
            this._public = _public;
        }
    }
}
