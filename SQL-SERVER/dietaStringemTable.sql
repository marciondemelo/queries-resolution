  
CREATE FUNCTION [dbo].[TFN_SplitText] (@Texto VARCHAR(8000),  
  
                                   @Delim VARCHAR(3)   )  
  
   
  
RETURNS @tItens TABLE (Item  INT           IDENTITY(1,1) NOT NULL,  
  
                       Linha VARCHAR(8000)                   NULL)  
  
   
  
AS  
  
   BEGIN  
  
      DECLARE @CurrentID       VARCHAR(8000)  
  
      DECLARE @CurrentPosition INT  
  
   
  
      IF @Delim = ''  
  
         RETURN  
  
   
  
      SET @Texto = LTRIM(RTRIM(@Texto))+ @Delim  
  
      SET @CurrentPosition = CHARINDEX(@Delim, @Texto, 1)  
  
   
  
      IF REPLACE(@Texto, @Delim, '') <> ''  
  
         BEGIN  
  
            WHILE @CurrentPosition > 0  
  
               BEGIN  
  
                  SET @CurrentID = LTRIM(RTRIM(LEFT(@Texto, @CurrentPosition - 1)))  
  
                  IF @CurrentID <> ''  
  
                     INSERT INTO @tItens VALUES (@CurrentID)  
  
   
  
                  SET @Texto = RIGHT(@Texto, LEN(@Texto) - @CurrentPosition)  
  
                  SET @CurrentPosition = CHARINDEX(@Delim, @Texto, 1)  
  
   
  
               END  
  
         END  
  
   
  
      RETURN  
  
   END  
  